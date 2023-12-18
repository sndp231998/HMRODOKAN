package com.hmro.dokan;


import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;


import com.hmro.dokan.playloads.UserDto;

//@EntityScan(basePackages = {"com.hmro.dokan.entities"}, excludeFilters = @Filter(type = FilterType.ASSIGNABLE_TYPE, classes = UserDto.class))

@SpringBootApplication

public class HmrodokanApplication {

	public static void main(String[] args) {
		SpringApplication.run(HmrodokanApplication.class, args);
	}

}
