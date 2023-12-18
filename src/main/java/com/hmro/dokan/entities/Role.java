package com.hmro.dokan.entities;
import jakarta.persistence.Id;

import jakarta.persistence.Entity;
import lombok.Data;
@Data
@Entity
public class Role {
	@Id	
	private int id;
	
	private String name;
	
}
