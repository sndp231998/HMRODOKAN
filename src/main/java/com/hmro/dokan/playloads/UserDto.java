package com.hmro.dokan.playloads;


import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "users")
@NoArgsConstructor
@Getter
@Setter
public class UserDto {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotEmpty
    @Size(min = 4, message = "Username must be a minimum of 4 characters!")
    private String name;

    @Email(message = "Email address is not valid!")
    @NotEmpty(message = "Email is required!")
    private String email;

    @NotEmpty
    @Size(min = 3, max = 10, message = "Password must be between 3 and 10 characters!")
    private String password;

//    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
//    private Set<RoleDto> roles = new HashSet<>();

    // Other fields and methods as needed
}
