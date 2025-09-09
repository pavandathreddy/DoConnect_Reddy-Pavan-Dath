import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterLink } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { AuthService, LoginRequest } from '../services/auth.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css'],
})
export class LoginComponent {
  email = '';
  password = '';
  errorMessage = '';

  constructor(private authService: AuthService, private router: Router) {}

  login() {
    const loginData: LoginRequest = {
      email: this.email, // ⚠️ your backend expects Email, not username → adjust service
      password: this.password,
    };

    this.authService.login(loginData).subscribe({
      next: (res) => {
        console.log('Login success:', res);
        this.router.navigate(['/']); // go to home/dashboard
      },
      error: (err) => {
        console.error('Login failed', err);
        this.errorMessage = 'Invalid email or password';
      },
    });
  }
}
