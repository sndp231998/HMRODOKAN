package com.hmro.dokan.playloads;

import java.sql.Date;

import com.hmro.dokan.entities.Categories;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
@Entity
public class ProductDto {


	@Id
	private int pid;

	private String title;

   private float sp;
	
	@Column(name="purchase_price")
	   private float pp;
	
	private float quantity;
	
	private String scancode;

	private String discount;
	
	private Integer category_id;
	
   private Date addedDate;
   
   private String imageName;
   
	//private String store_id;
	
	@ManyToOne

	private Categories category;
	

	private UserDto user;
	
	//private Set<..Dto> comments=new HashSet<>();

	
	
	
//	@OneToMany(mappedBy="product",cascade=CascadeType.All)
//	private Set<>
	

	
}
