package com.hmro.dokan.repositories;
import com.hmro.dokan.entities.*;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ProductRepo extends  JpaRepository<Products, Integer> {

	
	List<Products>findByCategory(Categories category);
	
	//Eg: counter-1 le entries garako products...etc
	List<Products>findByUser(Users user);
	
	@Query("select p from Product p where p.title like :key")
	List<Products>searchByTitle(@Param("key")String title);
	
	
	List<Products>findByScancode(String scancode);
}
