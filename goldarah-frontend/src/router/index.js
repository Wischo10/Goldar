import { createRouter, createWebHistory } from "vue-router";
import HomePage from "../views/HomePage.vue";
import AddGolonganDarah from "../views/AddGolonganDarah.vue";

const routes = [
  { path: "/", name: "HomePage", component: HomePage },
  { path: "/add-golongan", name: "AddGolonganDarah", component: AddGolonganDarah },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
