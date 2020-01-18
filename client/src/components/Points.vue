<template>
<body>
  <nav class="navbar navbar-expand-lg navbar-light navbar-laravel">
    <div class="container">
      <a class="navbar-brand" href="#">Points: {{pointsBind}}</a>
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
            <a class="nav-link" name="home" href="#" @click="home">Home</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="#" @click="logout">Log out</a>
          </li>
        </ul>
      </div>
    </div>
  </nav>
  <div id="main-content" class="justify-content-center">
    <div id="main-header" class="col-12">
      <h3 class="text-center">Buy points</h3>
      <hr class="accent my-5" />
    </div>
    <div class="container">
      <div class="row">
        <div class="col-xs-12 col-md-4 offset-md-4">
          <div class="card">
            <div class="card-header">
              <div class="row">
                <img
                  class="img-fluid"
                  src="http://www.milkshakedesign.com/wp-content/uploads/2018/12/paypal-logo-payment.png"
                />
              </div>
            </div>
            <div class="card-block">
              <form @submit="processPayment" method="POST">
                <div class="form-group col-md-12">
                  <label for="cc-name" class="control-label mb-1">Points</label>
                  <input class="form-control" type="number" value="15" id="points" />
                </div>
                <div class="form-group col-md-12">
                  <label for="cc-name" class="control-label mb-1">Name on card</label>
                  <input id="card_name" class="form-control" v-bind:value="this.getFullName()" />
                </div>
                <div class="form-group col-md-12">
                  <label for="cc-number" class="control-label mb-1">Card number</label>
                  <input
                    id="card_number"
                    class="form-control"
                    value="378282246310005"
                    oninvalid="setCustomValidity('Invalid card number')"
                    onchange="try{setCustomValidity('')}catch(e){}"
                    pattern="(?:4[0-9]{12}(?:[0-9]{3})?|[25][1-7][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})"
                  />
                </div>
                <div class="row">
                  <div class="col-6">
                    <div class="form-group col-md-12">
                      <label for="cc-exp" class="control-label mb-1">Expiring date</label>
                      <input
                        id="expiring_date"
                        class="form-control"
                        value="12/25"
                        placeholder="MM/YY"
                        oninvalid="setCustomValidity('MM/YY')"
                        onchange="try{setCustomValidity('')}catch(e){}"
                        pattern="\d{2}[\/]\d{2}"
                      />
                    </div>
                  </div>
                  <div class="col-6">
                    <div class="form-group col-md-12">
                      <label for="x_card_code" class="control-label mb-1">Security code</label>
                      <div class="input-group">
                        <input
                          id="cvc"
                          class="form-control"
                          value="756"
                          pattern="^[0-9]{3,4}$"
                          oninvalid="setCustomValidity('three or four digits')"
                          onchange="try{setCustomValidity('')}catch(e){}"
                          maxlength="4"
                        />
                      </div>
                    </div>
                  </div>
                </div>
                <div class="card-footer">
                  <p v-if="errors.length">
                    <li v-for="error in errors" style="list-style-type: none">
                      <span class="text-danger">{{ error }}</span>
                    </li>
                  </p>
                  <button
                    id="payment-button"
                    type="submit"
                    class="btn btn-lg btn-primary btn-block"
                  >Process payment</button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</body>
</template>

<script>
export default {
  name: "points",
  data() {
    return {
      errors: [],
      points: null,
      card_name: null,
      card_number: null,
      expiring_date: null,
      cvc: null,
      pointsBind: this.$session.get("user").points
    };
  },
  methods: {
    home: function() {
      this.$router.push("/home");
    },
    logout: function() {
      this.$session.destroy();
      this.$router.push("/");
    },
    getFullName: function() {
      return (
        this.$session.get("user").firstname +
        " " +
        this.$session.get("user").lastname
      );
    },
    processPayment: function(e) {
      e.preventDefault();
      this.postPayment().then(
        function(result) {
          this.pointsBind = 0;
          if (result["status"] != 200) {
            this.errors.push(result["body"]["message"]);
          } else {
            this.user = this.session.get("user");
            this.newPoints = (
              parseFloat(this.session.get("user").points) +
              parseFloat(points.value)
            ).toFixed(2);
            this.user.points = this.newPoints;
            this.pointsBind = this.newPoints;
            this.session.set("user", this.user);
            alert(result["body"]["message"]);
          }
        }.bind({
          errors: this.errors,
          session: this.$session,
          pointsBind: this.pointsBind
        })
      );
      //this.pointsBind = this.newPoints;
    },
    async postPayment() {
      let url = "http://localhost/zerowaste/api/payment";
      let username = this.$session.get("user").username;
      let password = this.$session.get("user").password;
      let options = {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: "Basic " + btoa(username + ":" + password)
        },
        body: JSON.stringify({
          card_number: card_number.value,
          card_name: card_name.value,
          expiring_date: expiring_date.value,
          cvc: cvc.value,
          points: points.value
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
<style scoped>
</style>
