<template>
  <div class="add-golongan-container">
    <h2>Form Donasi Golongan Darah</h2>
    <form @submit.prevent="submitGolonganDarah" class="golongan-form">
      <div class="form-group">
        <label for="name">Nama:</label>
        <input 
          id="name" 
          type="text" 
          v-model="name" 
          required 
          placeholder="Masukkan nama Anda"
        />
      </div>
      <div class="form-group">
        <label for="phone">Nomor HP:</label>
        <input 
          id="phone" 
          type="tel" 
          v-model="phone" 
          required 
          placeholder="Masukkan nomor HP Anda"
        />
      </div>
      <div class="form-group">
        <label for="golonganDarah">Golongan Darah:</label>
        <select id="golonganDarah" v-model="golonganDarah" required>
          <option value="" disabled>Pilih golongan darah</option>
          <option value="A">A</option>
          <option value="B">B</option>
          <option value="AB">AB</option>
          <option value="O">O</option>
        </select>
      </div>
      <button type="submit" class="submit-btn">Submit</button>
    </form>
  </div>
</template>

<script>
import Web3 from "web3";
import GolDarahContract from "../contracts/GolDarah.json";

export default {
  data() {
    return {
      name: "",
      phone: "",
      golonganDarah: "",
      contract: null,
      account: null,
    };
  },
  methods: {
    async submitGolonganDarah() {
      try {
        const response = await this.contract.methods
          .addGolonganDarah(this.name, this.phone, this.golonganDarah)
          .send({ from: this.account });
        console.log(response);
        alert("Data berhasil disimpan!");
        this.name = "";
        this.phone = "";
        this.golonganDarah = ""; // Reset form setelah berhasil
      } catch (error) {
        if (error.code === 4001) {
          alert("Transaksi dibatalkan oleh pengguna.");
        } else {
          alert("Terjadi kesalahan saat menyimpan data: " + error.message);
        }
      }
    },
    async requestAccountAccess() {
      try {
        await window.ethereum.request({ method: "eth_requestAccounts" });
      } catch (error) {
        if (error.code === -32002) {
          alert("Permintaan akses akun sudah ada. Silakan periksa MetaMask dan respon permintaan yang tertunda.");
        } else {
          throw error;
        }
      }
    },
  },
  mounted() {
    (async () => {
      try {
        if (typeof window.ethereum !== "undefined") {
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
        } else {
          alert("MetaMask tidak terdeteksi. Silakan instal MetaMask terlebih dahulu.");
        }
      } catch (error) {
        console.error("Gagal menginisialisasi Web3 atau kontrak: ", error);
      }
    })();
  },
};
</script>


<style scoped>
.add-golongan-container {
  max-width: 600px;
  margin: 50px auto;
  padding: 20px;
  background-color: #f9f9f9;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

h2 {
  text-align: center;
  color: #333;
  margin-bottom: 20px;
}

.golongan-form {
  display: flex;
  flex-direction: column;
}

.form-group {
  margin-bottom: 20px;
}

label {
  font-weight: bold;
  margin-bottom: 8px;
  display: block;
}

input, select {
  width: 100%;
  padding: 10px;
  font-size: 16px;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
}

.submit-btn {
  background-color: #FF8000;
  color: white;
  padding: 12px 20px;
  font-size: 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s;
  width: 100%;
}

.submit-btn:hover {
  background-color: #2980b9;
}
</style>
