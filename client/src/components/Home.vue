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
              href="#"
              @click="points"
            >Points: {{ userPoints }}</a>
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
      <h3 class="text-center">Daily menu</h3>
      <hr class="accent my-5" />
    </div>
    <div class="card-columns col-md-9">
      <div
        v-bind:id="menu.id"
        @mouseover="mouseOver"
        class="card"
        v-for="menu in menuList"
        @click="showDialog"
      >
        <div v-bind:id="menu.id" class="card-body">
          <span class="float-right font-weight-bold">${{ menu["price"]}}</span>
          <h6 class="text-underline">{{ menu["name"]}}</h6>
          <p class="small">{{ menu["ingredients"]}}</p>
          <img v-bind:src="menu.photo" class="card-img-top" />
          <span class="font-weight-bold small"></span>
        </div>
      </div>
    </div>
    <div v-if="showModal">
      <transition name="modal">
        <div class="modal-mask">
          <div class="modal-wrapper">
            <div class="modal-dialog" role="document">
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title">Order a menu</h5>
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true" @click="showModal = false">&times;</span>
                  </button>
                </div>
                <div class="modal-body">
                  <div class="row no-gutters">
                    <div class="col-md-4">
                      <img v-bind:src="selectedMenu.photo" class="card-img" />
                    </div>
                    <div class="col-md-8">
                      <div class="card-body">
                        <span class="float-right font-weight-bold">${{ selectedMenu.price}}</span>
                        <h5 class="card-title">{{selectedMenu.name}}</h5>
                        <div class="form-group">
                          <small class>{{selectedMenu.ingredients }}</small>
                          <p>
                            <small class="text-muted">Allergies: {{selectedMenu.allergies}}</small>
                          </p>
                        </div>
                      </div>
                    </div>
                  </div>
                  <!-- <div class="card">
                    <img v-bind:src="selectedMenu.photo" style="max-width: 140px;" class="card-img-top" alt="..." />
                    <div class="card-body">
                      <h5 class="card-title">Card title</h5>
                      <p
                        class="card-text"
                      >This is a wider card with supporting text below as a natural lead-in to additional content. This content is a little bit longer.</p>
                      <p class="card-text">
                        <small class="text-muted">Last updated 3 mins ago</small>
                      </p>
                    </div>
                  </div>-->
                </div>
                <div class="modal-footer">
                  <!-- <label class="">Total Cost ($) : 11</label> -->
                  <p v-if="errors.length">
                    <li v-for="error in errors" style="list-style-type: none">
                      <span class="text-danger col-md-6">{{ error }}</span>
                    </li>
                  </p>
                  <p v-if="success.length">
                    <li v-for="msg in success" style="list-style-type: none">
                      <span class="text-success col-md-6">{{ msg }}</span>
                    </li>
                  </p>
                  <button type="button" class="btn btn-secondary" @click="showModal = false">Close</button>
                  <button type="button" class="btn btn-primary" @click="order">Order</button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </transition>
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
  name: "home",
  data() {
    return {
      menuList: [],
      showModal: false,
      selectedMenu: null,
      userPoints: 0,
      errors: [],
      success: []
    };
  },
  beforeCreate: function() {
    if (!this.$session.exists()) {
      this.$router.push("/");
    }
  },
  created: function() {
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
    this.userPoints = this.$session.get("user")["points"];
  },
  methods: {
    logout: function() {
      this.$session.destroy();
      this.$router.push("/");
    },
    points: function() {
      this.$router.push("/points");
    },
    mouseOver: function(e) {
      //e.srcElement.addClass("shadow-lg");
    },
    order: function() {
      this.errors = [];
      this.success = [];
      this.processOrder().then(
        function(result) {
          if (result["status"] == 200) {
            console.log(result["body"].message);
            this.userPoints = (
              parseFloat(this.userPoints) - parseFloat(this.selectedMenu.price)
            ).toFixed(2);
            this.user = this.session.get("user");
            this.user.points = this.userPoints;
            this.session.set("user", this.user);
            this.success.push(result["body"].message);
          } else {
            this.errors.push(result["body"].message);
          }
        }.bind({
          menuList: this.menuList,
          errors: this.errors,
          userPoints: this.userPoints,
          session: this.$session,
          selectedMenu: this.selectedMenu,
          success: this.success
        })
      );
    },
    async processOrder() {
      let url = "http://localhost/zerowaste/api/order/create";
      let username = this.$session.get("user").username;
      let password = this.$session.get("user").password;
      let options = {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: "Basic " + btoa(username + ":" + password)
        },
        body: JSON.stringify({
          menu_id: this.selectedMenu.id,
          quantity: 1
        })
      };
      console.log(options.body);
      let response = await fetch(url, options).then(r =>
        r.json().then(data => ({ status: r.status, body: data }))
      );
      return response;
    },
    showDialog: function(e) {
      this.showModal = true;
      this.errors = [];
      this.success = [];
      this.targetId =
        e.target.parentElement.id == null
          ? e.target.id
          : e.target.parentElement.id;
      this.selectedMenu = this.menuList[this.targetId - 1];
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
.modal-mask {
  position: fixed;
  z-index: 9998;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: table;
  transition: opacity 0.3s ease;
}

.modal-wrapper {
  display: table-cell;
  vertical-align: middle;
}
.card {
  cursor: pointer;
}
</style>
