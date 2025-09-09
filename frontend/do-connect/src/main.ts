import { bootstrapApplication } from '@angular/platform-browser';
import { provideRouter } from '@angular/router';
import { AppComponent } from './app/app.component';
import { HomeComponent } from './app/home/home.component';
import { LoginComponent } from './app/login/login.component';
import { RegisterComponent } from './app/register/register.component';

bootstrapApplication(AppComponent, {
  providers: [
    provideRouter([
      { path: '', component: HomeComponent },         // home page
      { path: 'login', component: LoginComponent },   // /login
      { path: 'register', component: RegisterComponent }, // /register
    ]),
  ],
}).catch(err => console.error(err));
