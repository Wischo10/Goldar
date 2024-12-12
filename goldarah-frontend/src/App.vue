<template>
  <div id="app">
    <nav class="navbar">
      <router-link to="/" class="nav-link">Home</router-link>
      <router-link to="/add-golongan" class="nav-link">Tambah Golongan Darah</router-link>
    </nav>
    <router-view />
  </div>
</template>

<script>
export default {
  name: "App",
};
</script>

<style scoped>
.navbar {
  background-color: #FF8000;
  padding: 10px 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.nav-link {
  color: white;
  text-decoration: none;
  font-size: 18px;
  margin: 0 10px;
}

.nav-link:hover {
  text-decoration: underline;
}
</style>
