class SignupJson {
  
  String userName;
  String password;

  SignupJson(this.password, this.userName);

  Map toJson() =>{
    'userName': userName,
    'password': password,
  };

}