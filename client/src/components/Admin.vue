<template>
<body>
  <nav class="navbar navbar-expand-lg navbar-light navbar-laravel">
    <div class="container">
      <a class="navbar-brand" href="#">Welcome, {{ this.$session.get("user")["firstname"]}}!</a>
      <button
        class="navbar-toggler"
        type="button"
        data-toggle="collapse"
        data-target="#navbarSupportedContent"
        aria-controls="navbarSupportedContent"
        aria-expanded="false"
        aria-label="Toggle navigation"
      >
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav ml-auto">
          <li class="nav-item">
            <a
              class="nav-link"
              name="user_information"
              @click="registerMenu"
              href="#"
            >Register Menu</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="#" @click="logout">Log out</a>
          </li>
        </ul>
      </div>
    </div>
  </nav>
  <div id="main-content" class>
    <div id="main-header" class="col-12">
      <h3 class="text-center">Daily Orders</h3>
      <hr class="accent my-5" />
    </div>
    <div class="card-columns">
      <div class="card" v-for="menu in menuList">
        <div class="card-body">
          <span
            class="float-right font-weight-bold"
          >${{ (menu["price"] * orders.filter(equalsToMenu(menu["id"])).length).toFixed(2)}}</span>
          <h6 class="text-underline">{{ menu["name"]}}</h6>
          <div>
            <small class="small text-muted">Price for each: ${{ menu["price"] }}</small>
            <small
              class="small text-muted float-right"
            >Quantity: {{ orders.filter(equalsToMenu(menu["id"])).length}}</small>
          </div>
          <div>
            <small
              class="small text-muted"
            >Ordered by: {{ new Set(orders.filter(equalsToMenu(menu["id"])).map(mapUsers)).values().next().value}}</small>
            <small
              class="small text-muted float-right"
            >{{ new Set(orders.filter(equalsToMenu(menu["id"])).map(mapEmail)).values().next().value}}</small>
          </div>
        </div>
      </div>
    </div>
  </div>
</body>
<!-- <body>
  <div id="app">
    
    <button @click="showModal = true">Click</button>
  </div>
</body>-->
</template>
<script>
export default {
  name: "admin",
  data() {
    return {
      orders: [],
      menuList: []
    };
  },
  beforeCreate: function() {},
  created: function() {
    this.getOrdersList().then(
      function(result) {
        if (result["status"] == 200) {
          for (var i = 0; i < result["body"].length; i++) {
            this.orders.push(result["body"][i]);
          }
        }
      }.bind({
        orders: this.orders
      })
    );
    this.getMenuList().then(
      function(result) {
        if (result["status"] == 200) {
          for (var i = 0; i < result["body"].length; i++) {
            this.menuList.push(result["body"][i]);
          }
        }
      }.bind({
        menuList: this.menuList
      })
    );
  },
  methods: {
    mapEmail($order) {
      return $order.user.email;
    },
    mapUsers($order) {
      return $order.user.firstname + " " + $order.user.lastname;
    },
    equalsToMenu($id) {
      return function(element) {
        return element.menu.id === $id;
      };
    },
    equalsToUser($id) {
      return function(element) {
        return element.person_id === $id;
      };
    },
    registerMenu: function() {
      this.$router.push("/menu");
    },
    logout: function() {
      this.$session.destroy();
      this.$router.push("/");
    },
    async getOrdersList() {
      let url = "http://localhost/zerowaste/api/orders/*";
      let username = this.$session.get("user").username;
      let password = this.$session.get("user").password;
      let options = {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          Authorization: "Basic " + btoa(username + ":" + password)
        }
      };
      let response = await fetch(url, options).then(r =>
        r.json().then(data => ({ status: r.status, body: data }))
      );
      return response;
    },
    async getMenuList() {
      let url = "http://localhost/zerowaste/api/menu/*";
      let username = this.$session.get("user").username;
      let password = this.$session.get("user").password;
      let options = {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          Authorization: "Basic " + btoa(username + ":" + password)
        }
      };
      let response = await fetch(url, options).then(r =>
        r.json().then(data => ({ status: r.status, body: data }))
      );
      return response;
    }
  }
};
</script>
<style>
</style>
