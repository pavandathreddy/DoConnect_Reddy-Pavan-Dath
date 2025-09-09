import { Routes } from '@angular/router';
import { LoginComponent } from './login/login.component';
import { RegisterComponent } from './register/register.component';
import { QuestionListComponent } from './question-list/question-list.component';
import { QuestionDetailComponent } from './question-detail/question-detail.component';
import { AskQuestionComponent } from './ask-question/ask-question.component';
import { AdminDashboardComponent } from './admin/admin-dashboard.component';

export const appRoutes: Routes = [
  { path: '', redirectTo: 'login', pathMatch: 'full' },  // 👈 Start with login
  { path: 'login', component: LoginComponent },
  { path: 'register', component: RegisterComponent },
  { path: 'questions', component: QuestionListComponent },
  { path: 'question/:id', component: QuestionDetailComponent },
  { path: 'ask', component: AskQuestionComponent },
  { path: 'admin', component: AdminDashboardComponent },
  { path: '**', redirectTo: 'login' } // fallback
];
