import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpClientModule } from '@angular/common/http';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-question-list',
  standalone: true,
  imports: [
    CommonModule,     // For *ngFor, *ngIf
    HttpClientModule  // For HttpClient
  ],
  templateUrl: './question-list.component.html'
})
export class QuestionListComponent implements OnInit {
  questions: any[] = [];

  constructor(private http: HttpClient, private router: Router) {}

  ngOnInit() {
    this.http.get<any[]>('http://localhost:5291/api/questions').subscribe(data => {
      this.questions = data;
    });
  }

  viewDetail(id: number) {
    this.router.navigate(['/question', id]);
  }
}
