import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterLink } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { AuthService, RegisterRequest } from '../services/auth.service';

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.css'],
})
export class RegisterComponent {
  name = '';
  email = '';
  password = '';
  errorMessage = '';

  constructor(private authService: AuthService, private router: Router) {}

  register() {
    const registerData: RegisterRequest = {
      username: this.name,
      email: this.email,
      password: this.password,
      role: 'User',
    };

    this.authService.register(registerData).subscribe({
      next: (res) => {
        console.log('Register success:', res);
        this.router.navigate(['/login']);
      },
      error: (err) => {
        console.error('Register failed', err);
        this.errorMessage = 'Registration failed. Try again.';
      },
    });
  }
}
