package com.example.helloworld;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class GreeterController {

    @GetMapping("/greet")
    public ResponseEntity<String> sayHello() {
        return ResponseEntity.ok("Hello there!!");
    }
}
