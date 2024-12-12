<template>
  <div class="home-container">
    <h1>Data Golongan Darah</h1>
    <div v-if="loading" class="loading">Memuat data...</div>
    <ul v-if="!loading && golonganDarahList.length > 0" class="data-list">
      <li v-for="(item, index) in golonganDarahList" :key="index">
        <strong>Address:</strong> {{ item.sender }}<br />
        <strong>Nama:</strong> {{ item.name }}<br />
        <strong>Nomor HP:</strong> {{ item.phone }}<br />
        <strong>Golongan Darah:</strong> {{ item.bloodType }}
      </li>
    </ul>
    <p v-if="!loading && golonganDarahList.length === 0">Tidak ada data yang tersimpan.</p>
  </div>
</template>


<script>
import Web3 from "web3";
import GolDarahContract from "../contracts/GolDarah.json";

export default {
  data() {
    return {
      loading: true,
      golonganDarahList: [],
      contract: null,
      account: null,
      isRequesting: false,
    };
  },
  methods: {
    async loadData() {
      try {
        const totalData = await this.contract.methods.getGolonganDarahCount().call();
        const fetchedDataList = [];

        for (let i = 0; i < totalData; i++) {
          const record = await this.contract.methods.getGolonganDarah(i).call();
          fetchedDataList.push({
            sender: record[0],
            name: record[1],
            phone: record[2],
            bloodType: record[3],
          });
        }

        this.golonganDarahList = fetchedDataList;
      } catch (error) {
        console.error("Error loading data:", error);
        alert("Terjadi kesalahan saat memuat data: " + error.message);
      } finally {
        this.loading = false;
      }
    },
    async requestAccountAccess() {
      if (this.isRequesting) {
        console.log("Already processing eth_requestAccounts. Please wait.");
        return;
      }

      this.isRequesting = true;
      try {
        await window.ethereum.request({ method: "eth_requestAccounts" });
      } catch (error) {
        if (error.code === -32002) {
          alert("Permintaan akses akun sudah ada. Silakan periksa MetaMask dan respon permintaan yang tertunda.");
        } else {
          throw error;
        }
      } finally {
        this.isRequesting = false;
      }
    },
  },
  async mounted() {
    try {
      if (typeof window.ethereum === "undefined") {
        throw new Error("Metamask atau penyedia Ethereum lainnya tidak terdeteksi.");
      }

      const web3 = new Web3(window.ethereum);

      // Minta akses akun
      await this.requestAccountAccess();

      // Dapatkan akun aktif
      const accounts = await web3.eth.getAccounts();
      if (accounts.length === 0) {
        alert("Tidak ada akun Ethereum yang terdeteksi. Silakan login ke MetaMask.");
        return;
      }
      this.account = accounts[0];

      // Inisialisasi kontrak
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = GolDarahContract.networks[networkId];
      if (!deployedNetwork) {
        alert("Kontrak tidak ditemukan di jaringan ini.");
        return;
      }
      this.contract = new web3.eth.Contract(
        GolDarahContract.abi,
        deployedNetwork.address
      );

      await this.loadData();
    } catch (error) {
      console.error("Gagal menginisialisasi Web3 atau kontrak: ", error);
    }
  },
};
</script>



<style scoped>
.home-container {
  max-width: 800px;
  margin: 50px auto;
  padding: 20px;
  background-color: #f9f9f9;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

h1 {
  text-align: center;
  color: #333;
  margin-bottom: 20px;
}

.loading {
  text-align: center;
  font-size: 18px;
  color: #888;
}

.data-list {
  list-style: none;
  padding: 0;
}

.data-list li {
  background-color: #eaf2f8;
  margin: 10px 0;
  padding: 15px;
  border-radius: 6px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.data-list li strong {
  color: #333;
}
</style>