// ============================================
import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
import { AuthService } from './auth.service';

export interface Question {
  questionId: number;
  userId: number;
  title: string;
  body: string;
  status: string;
  createdAt: Date;
  user: any;
  answers: Answer[];
  images: any[];
}

export interface Answer {
  answerId: number;
  questionId: number;
  userId: number;
  body: string;
  status: string;
  createdAt: Date;
  user: any;
  images: any[];
}

export interface CreateQuestionRequest {
  title: string;
  body: string;
}

export interface CreateAnswerRequest {
  questionId: number;
  body: string;
}

@Injectable({
  providedIn: 'root'
})
export class QuestionService {
  private apiUrl = 'https://localhost:7000/api'; // Update to your backend port

  constructor(private http: HttpClient, private authService: AuthService) {}

  getApprovedQuestions(): Observable<Question[]> {
    return this.http.get<Question[]>(`${this.apiUrl}/questions/approved`);
  }

  searchQuestions(query: string): Observable<Question[]> {
    return this.http.get<Question[]>(`${this.apiUrl}/questions/search?q=${encodeURIComponent(query)}`);
  }

  getQuestionById(id: number): Observable<Question> {
    return this.http.get<Question>(`${this.apiUrl}/questions/${id}`);
  }

  createQuestion(questionData: CreateQuestionRequest): Observable<Question> {
    const headers = this.authService.getAuthHeaders();
    return this.http.post<Question>(`${this.apiUrl}/questions`, questionData, { headers });
  }

  createAnswer(answerData: CreateAnswerRequest): Observable<Answer> {
    const headers = this.authService.getAuthHeaders();
    return this.http.post<Answer>(`${this.apiUrl}/answers`, answerData, { headers });
  }

  uploadImage(file: File, questionId?: number, answerId?: number): Observable<any> {
    const formData = new FormData();
    formData.append('file', file);
    if (questionId) formData.append('questionId', questionId.toString());
    if (answerId) formData.append('answerId', answerId.toString());

    const token = this.authService.getToken();
    const headers = new HttpHeaders({
      'Authorization': `Bearer ${token}`
    });

    return this.http.post(`${this.apiUrl}/images/upload`, formData, { headers });
  }
}