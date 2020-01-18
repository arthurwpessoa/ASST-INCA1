<template>
<body>
  <nav class="navbar navbar-expand-lg navbar-light navbar-laravel">
    <div class="container">
      <a class="navbar-brand" href="#">Register Menu</a>
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
            <a class="nav-link" name="user_information" @click="orders" href="#">Orders</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="#" @click="logout">Log out</a>
          </li>
        </ul>
      </div>
    </div>
  </nav>
  <div id="main-content">
    <div class="cotainer">
      <div class="row justify-content-center">
        <div class="col-md-7">
          <div class="card">
            <div class="card-header">Register a menu</div>
            <div class="card-body">
              <form name="registration_form" @submit="register" method="POST">
                <div class="form-group row">
                  <label for="title" class="col-md-4 col-form-label text-md-right">Title*</label>
                  <div class="col-md-6">
                    <input type="text" id="title" class="form-control" name="title" />
                  </div>
                </div>
                <div class="form-group row">
                  <label for="date" class="col-md-4 col-form-label text-md-right">Date*</label>
                  <div class="col-md-6">
                    <input
                      type="text"
                      placeholder="YYYY/MM/DD"
                      oninvalid="setCustomValidity('YYYY/MM/DD')"
                      onchange="try{setCustomValidity('')}catch(e){}"
                      pattern="^(19|20)\d\d[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])$"
                      id="date"
                      class="form-control"
                      name="date"
                    />
                  </div>
                </div>
                <div class="form-group row">
                  <label for="ingredients" class="col-md-4 col-form-label text-md-right">Ingedients*</label>
                  <div class="col-md-6">
                    <input type="text" id="ingredients" class="form-control" name="ingredients" />
                  </div>
                </div>
                <div class="form-group row">
                  <label for="price" class="col-md-4 col-form-label text-md-right">Price*</label>
                  <div class="col-md-6">
                    <input id="price" type="number" step="any" class="form-control" name="price" />
                  </div>
                </div>
                <div class="form-group row">
                  <label for="allergies" class="col-md-4 col-form-label text-md-right">Allergies</label>
                  <div class="col-md-6">
                    <input type="text" id="allergies" class="form-control" name="allergies" />
                  </div>
                </div>
                <div class="form-group row">
                  <label
                    for="exampleFormControlFile1"
                    class="col-md-4 col-form-label text-md-right"
                  >Image</label>
                  <div class="col-md-6">
                    <input type="file" class="form-control-file" id="exampleFormControlFile1" />
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
      title: null,
      date: null,
      price: null,
      ingredients: null,
      errors: []
    };
  },
  methods: {
    logout: function() {
      this.$session.destroy();
      this.$router.push("/");
    },
    orders: function() {
      this.$router.push("/admin");
    },
    register: function(e) {
      this.errors = [];
      e.preventDefault();
      var myTitle = title.value;
      if (myTitle == "") {
        this.errors.push("*The title field is required");
        return false;
      }
      var myDate = date.value;
      if (myDate == "") {
        this.errors.push("*The date field is required");
        return false;
      }
      var myIngredients = ingredients.value;
      if (myIngredients == "") {
        this.errors.push("*The ingredients field is required");
        return false;
      }
      var myPrice = price.value;
      if (myPrice == "") {
        this.errors.push("*The price field is required");
        return false;
      }
      var myAllergies = allergies.value;
      this.registerMenu(
        myTitle,
        myIngredients,
        myPrice,
        myDate,
        myAllergies
      ).then(
        function(result) {
          if (result["status"] == 200) {
            console.log(result);
            alert(result.body.message);
          } else {
            this.errors.push(result.body["message"]);
          }
        }.bind({
          errors: this.errors
        })
      );
    },
    async registerMenu(myTitle, myIngredients, myPrice, myDate, myAllergies) {
      let url = "http://localhost/zerowaste/api/menu/register";
      let username = this.$session.get("user").username;
      let password = this.$session.get("user").password;
      let options = {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: "Basic " + btoa(username + ":" + password)
        },
        body: JSON.stringify({
          name: myTitle,
          ingredients: myIngredients,
          price: myPrice,
          date: myDate,
          allergies: myAllergies
        })
      };
      console.log(options.body);
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
