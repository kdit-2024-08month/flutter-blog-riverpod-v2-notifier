# RestAPI 서버 주소

https://github.com/kdit-2024-08month/spring-blog-restapi

# 레코드 문법

```dart
(String, int) hello() {
  return ("ssar", 1234);
}

void main() {
  var n = hello();
  print(n.$1);
  print(n.$2);
}


(String, int) hello() {
  return ("ssar", 1234);
}

void main() {
  var (username, password) = hello();
  print(username);
  print(password);
}


({String username, int password}) hello() {
  return (username:"ssar", password:1234);
}

void main() {
  var n = hello();
  print(n.username);
  print(n.password);
}
```