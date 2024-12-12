// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GolDarah {
    struct GolDarahData {
        address sender;
        string name;
        string phone;
        string bloodType;
    }

    GolDarahData[] public golonganDarahRecords;

    event GolonganDarahAdded(address indexed sender, string name, string phone, string bloodType);

    // Fungsi untuk menambahkan golongan darah
    function addGolonganDarah(string memory _name, string memory _phone, string memory _bloodType) public {
        require(bytes(_name).length > 0, "Nama tidak boleh kosong");
        require(bytes(_phone).length > 0, "Nomor HP tidak boleh kosong");
        require(bytes(_bloodType).length > 0, "Golongan darah tidak boleh kosong");

        golonganDarahRecords.push(GolDarahData(msg.sender, _name, _phone, _bloodType));
        emit GolonganDarahAdded(msg.sender, _name, _phone, _bloodType);
    }

    // Mendapatkan jumlah data golongan darah
    function getGolonganDarahCount() public view returns (uint) {
        return golonganDarahRecords.length;
    }

    // Mendapatkan data golongan darah berdasarkan indeks
    function getGolonganDarah(uint _index) public view returns (address, string memory, string memory, string memory) {
        require(_index < golonganDarahRecords.length, "Index out of bounds");
        GolDarahData memory data = golonganDarahRecords[_index];
        return (data.sender, data.name, data.phone, data.bloodType);
    }
}
