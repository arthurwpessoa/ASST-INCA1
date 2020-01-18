<template>
<body>
  <nav class="navbar navbar-expand-lg navbar-light navbar-laravel">
    <div class="container">
      <a class="navbar-brand">Register</a>
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
            <a class="nav-link" href="#" @click="login">Login</a>
          </li>
        </ul>
      </div>
    </div>
  </nav>

  <main class="registration_form">
    <div class="cotainer">
      <div class="row justify-content-center">
        <div class="col-md-7">
          <div class="card">
            <div class="card-header">Register</div>
            <div class="card-body">
              <form name="registration_form" @submit="register" method="POST">
                <div class="form-group row">
                  <label for="username" class="col-md-4 col-form-label text-md-right">Username*</label>
                  <div class="col-md-6">
                    <input type="text" id="username" class="form-control" name="middle-names" />
                  </div>
                </div>
                <div class="form-group row">
                  <label for="first_name" class="col-md-4 col-form-label text-md-right">First Name*</label>
                  <div class="col-md-6">
                    <input
                      type="text"
                      id="first_name"
                      class="form-control"
                      v-model="first_name"
                      v-on:input="clearErrros"
                      name="first-name"
                    />
                  </div>
                </div>
                <div class="form-group row">
                  <label for="last_name" class="col-md-4 col-form-label text-md-right">Last Name*</label>
                  <div class="col-md-6">
                    <input
                      type="text"
                      id="last_name"
                      class="form-control"
                      v-model="last_name"
                      v-on:input="clearErrros"
                      name="last_name"
                    />
                  </div>
                </div>
                <div class="form-group row">
                  <label for="password" class="col-md-4 col-form-label text-md-right">Password*</label>
                  <div class="col-md-6">
                    <input
                      type="password"
                      id="password"
                      class="form-control"
                      v-model="password"
                      v-on:input="clearErrros"
                      name="password"
                    />
                  </div>
                </div>
                <div class="form-group row">
                  <label
                    for="repeat_password"
                    class="col-md-4 col-form-label text-md-right"
                  >Repeat Password*</label>
                  <div class="col-md-6">
                    <input
                      type="password"
                      v-model="repeat_password"
                      v-on:input="clearErrros"
                      id="repeat_password"
                      class="form-control"
                      name="password"
                    />
                  </div>
                </div>
                <div class="form-group row">
                  <label
                    for="email_address"
                    class="col-md-4 col-form-label text-md-right"
                  >E-mail Address*</label>
                  <div class="col-md-6">
                    <input type="text" id="email_address" class="form-control" name="email-address" />
                  </div>
                </div>
                <div class="col-md-6 offset-md-4">
                  <p v-if="errors.length">
                    <li v-for="error in errors" style="list-style-type: none">
                      <span class="text-danger">{{ error }}</span>
                    </li>
                  </p>
                  <button name="register" type="submit" class="btn btn-primary">Register</button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  </main>
</body>
</template>

<script>
export default {
  name: "register",
  data() {
    return {
      username: null,
      first_name: null,
      last_name: null,
      password: null,
      repeat_password: null,
      email_address: null,
      errors: []
    };
  },
  methods: {
    login: function(e) {
      this.$router.push("/");
    },
    register: function(e) {
      e.preventDefault();
      this.errors = [];
      //Username validation
      var usernameRegex = /^(?=.{4,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+$/;
      var user = username.value;
      if (user == "") {
        this.errors.push("*The username field is required");
        return false;
      } else if (!usernameRegex.test(user)) {
        this.errors.push(
          "*The username must be at least 4 (min) and 20 (max) characters length containing numbers and special characters (._)"
        );
        return false;
      }
      //Only allow characters regardless of the case.
      var namePatternRegex = /^[a-zA-Z ]+$/;
      //First Name Validation
      var firstName = first_name.value;
      if (firstName == "") {
        this.errors.push("*The first name field is required");
        return false;
      } else if (!namePatternRegex.test(firstName)) {
        this.errors.push(
          "*Input first name contains invalid characters: " + firstName
        );
        return false;
      }
      // Last Name Validation
      var lastName = last_name.value;
      if (lastName == "") {
        this.errors.push("*The last name field is required");
        return false;
      } else if (!namePatternRegex.test(lastName)) {
        this.errors.push(
          "*Input last name contains invalid characters: " + lastName
        );
        return false;
      }
      //Password Validation
      var passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*])(?=.{6,})/;
      var pass = password.value;
      if (pass == "") {
        this.errors.push("*The password field is required");
        return false;
      } else if (!passwordRegex.test(pass)) {
        this.errors.push(
          "*The password must be at least 6 characters long with at least a letter, a number and a special character"
        );
        return false;
      }
      var repeatPass = repeat_password.value;
      if (pass != repeatPass) {
        this.errors.push("*Password fields do not match");
        return false;
      }
      //E-mail validation
      var emailRegex = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      var email = email_address.value;
      if (email == "") {
        this.errors.push("*You must specify an email address");
        return false;
      } else if (!emailRegex.test(email)) {
        this.errors.push("*Invalid e-mail address");
        return false;
      }
      this.postRegister().then(
        function(result) {
          if (result["status"] != 200) {
            this.errors.push(result["body"]["message"]);
          } else {
            alert(result["body"]["message"]);
            this.router.push("/");
          }
        }.bind({
          errors: this.errors,
          router: this.$router
        })
      );
    },
    async postRegister() {
      let url = "http://localhost/zerowaste/api/users/register";
      let options = {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({
          username: username.value,
          password: CryptoJS.MD5(this.password).toString(),
          firstname: first_name.value,
          lastname: last_name.value,
          admin: "false",
          email: email_address.value
        })
      };
      let response = await fetch(url, options).then(r =>
        r.json().then(data => ({ status: r.status, body: data }))
      );
      return response;
    },
    clearErrros: function(e) {
      if (this.errors.length > 0) {
        this.errors = [];
        this.errors.push("");
      }
    }
  }
};
</script>