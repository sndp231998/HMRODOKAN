package com.hmro.dokan.entities;

import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;

import java.util.Date;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import lombok.Data;
import lombok.NoArgsConstructor;


@Table(name="products")
@NoArgsConstructor
@Data
@Entity
public class Products {

	
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private int productId;

	//@Column(unique = true)
	@Column(name = "product_title", nullable = false, length = 20)
	private String title;

	@Column(name="selling_price")
   private float sp;
	
	@Column(name="purchase_price")
	   private float pp;
	
	@Column(name="quantity")
	private float qty;
	
	private String scancode;

	
   private Date addedDate;
   
   private String imageName;
   
	private String store_id;
	
	@ManyToOne
	@JoinColumn(name="category_id")
	private Categories category;
	
	@ManyToOne
   private Users user;
	
//	@OneToMany(mappedBy="product",cascade=CascadeType.All)
//	private Set<>
	

	
}
