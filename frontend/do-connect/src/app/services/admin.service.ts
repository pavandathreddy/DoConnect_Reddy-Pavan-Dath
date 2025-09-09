import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { AuthService } from './auth.service';
import { Answer, Question } from './question.service';

@Injectable({
  providedIn: 'root'
})
export class AdminService {
  private apiUrl = 'https://localhost:7000/api'; // Update to your backend port

  constructor(private http: HttpClient, private authService: AuthService) {}

  getPendingQuestions(): Observable<Question[]> {
    const headers = this.authService.getAuthHeaders();
    return this.http.get<Question[]>(`${this.apiUrl}/admin/questions/pending`, { headers });
  }

  getPendingAnswers(): Observable<Answer[]> {
    const headers = this.authService.getAuthHeaders();
    return this.http.get<Answer[]>(`${this.apiUrl}/admin/answers/pending`, { headers });
  }

  approveQuestion(questionId: number): Observable<any> {
    const headers = this.authService.getAuthHeaders();
    return this.http.put(`${this.apiUrl}/admin/questions/${questionId}/approve`, {}, { headers });
  }

  rejectQuestion(questionId: number): Observable<any> {
    const headers = this.authService.getAuthHeaders();
    return this.http.put(`${this.apiUrl}/admin/questions/${questionId}/reject`, {}, { headers });
  }

  approveAnswer(answerId: number): Observable<any> {
    const headers = this.authService.getAuthHeaders();
    return this.http.put(`${this.apiUrl}/admin/answers/${answerId}/approve`, {}, { headers });
  }

  rejectAnswer(answerId: number): Observable<any> {
    const headers = this.authService.getAuthHeaders();
    return this.http.put(`${this.apiUrl}/admin/answers/${answerId}/reject`, {}, { headers });
  }

  deleteQuestion(questionId: number): Observable<any> {
    const headers = this.authService.getAuthHeaders();
    return this.http.delete(`${this.apiUrl}/admin/questions/${questionId}`, { headers });
  }

  deleteAnswer(answerId: number): Observable<any> {
    const headers = this.authService.getAuthHeaders();
    return this.http.delete(`${this.apiUrl}/admin/answers/${answerId}`, { headers });
  }
}