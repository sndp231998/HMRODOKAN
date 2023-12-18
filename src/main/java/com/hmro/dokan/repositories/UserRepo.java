package com.hmro.dokan.repositories;
import java.util.List;
import java.util.Optional;

import org.apache.catalina.User;
import org.springframework.data.jpa.repository.JpaRepository;

import com.hmro.dokan.entities.*;


public interface UserRepo extends JpaRepository<Users,Integer>{

	Optional<User> findByEmail(String email);
	List<Sales>findByUser(User user);
	List<Products>findByUser(Products product);
	
}
