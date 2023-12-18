package com.hmro.dokan.entities;

import jakarta.persistence.Id;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import lombok.Data;

@Entity
@Data
public class Sales {

	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private int Sales_id;

	@Column(name = "Date_of_Sales", nullable = false)
	private String date;

	@Column(name="Payement_method", nullable=false)
	private String payement;
	
	@Column(name="Total_Amount", nullable=false)
	private float totalbill;
	
	private float discount;
	
	//--------------------
	
	private Integer store_id;
	private Integer counter_id;
	
}
