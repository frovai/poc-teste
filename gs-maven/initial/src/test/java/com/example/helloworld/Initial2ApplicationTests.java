package com.example.helloworld;

import org.hamcrest.Matchers;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import static org.junit.Assert.assertThat;


@RunWith(SpringRunner.class)
@SpringBootTest
public class Initial2ApplicationTests {

    private final Greeter greeter = new Greeter();

    @Test
    public void greeterSaysHello() {

        assertThat(greeter.sayHello(), Matchers.containsString("Hello"));
    }

}
