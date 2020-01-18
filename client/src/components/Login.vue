<template>
<body>
  <nav class="navbar navbar-expand-lg navbar-light navbar-laravel">
    <div class="container">
      <a class="navbar-brand">Login</a>
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
            <a class="nav-link" href="#" @click="register">Register</a>
          </li>
        </ul>
      </div>
    </div>
  </nav>
  <div class="cotainer">
    <div class="row justify-content-center">
      <div class="col-md-6">
        <div class="card">
          <div class="card-header">Login</div>
          <div class="card-body">
            <form id="login" @submit="authenticate" method="POST">
              <div class="form-group row">
                <label for="username" class="col-md-4 col-form-label text-md-right">Username</label>
                <div class="col-md-6">
                  <input
                    type="text"
                    id="username"
                    class="form-control"
                    name="username"
                    v-model="username"
                  />
                </div>
              </div>
              <div class="form-group row">
                <label for="password" class="col-md-4 col-form-label text-md-right">Password</label>
                <div class="col-md-6">
                  <input
                    type="password"
                    id="password"
                    class="form-control"
                    name="password"
                    v-model="password"
                  />
                  <p v-if="errors.length">
                    <span class="text-danger" v-for="error in errors">{{ error }}</span>
                  </p>
                </div>
              </div>
              <div class="col-md-6 offset-md-4">
                <button name="submit" type="submit" class="btn btn-primary">Login</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</body>
</template>

<script>
export default {
  data() {
    return {
      errors: [],
      username: null,
      password: null
    };
  },
  mounted() {
    let recaptchaScript = document.createElement("script");
    recaptchaScript.setAttribute(
      "src",
      "http://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.2/rollups/aes.js"
    );
    document.head.appendChild(recaptchaScript);
  },
  beforeCreate: function() {
    if (this.$session.exists()) {
      if (this.$session.get("user")["admin"] == true) {
        this.$router.push("/admin");
      } else this.$router.push("/home");
    }
  },
  methods: {
    authenticate: function(e) {
      this.errors = [];
      if (this.username && this.password) {
        this.postLogin().then(
          function(result) {
            if (result["status"] != 200) {
              this.errors.push(result["body"]["message"]);
            } else {
              result["body"]["password"] = this.password;
              this.session.set("user", result["body"]);
              if (result["body"].admin == true) this.router.push("admin");
              else this.router.push("home");
            }
          }.bind({
            errors: this.errors,
            router: this.$router,
            password: this.password,
            session: this.$session
          })
        );
      } else {
        this.errors.push("Username and password required.");
      }
      e.preventDefault();
    },
    register: function(e) {
      this.$router.push("register");
    },
    async postLogin() {
      let url = "http://localhost/zerowaste/api/users/login";
      let options = {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({
          username: this.username,
          password: CryptoJS.MD5(this.password).toString()
        })
      };
      let response = await fetch(url, options).then(r =>
        r.json().then(data => ({ status: r.status, body: data }))
      );
      return response;
    }
  }
};
</script>
<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
