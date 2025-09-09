import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClientModule } from '@angular/common/http';
import { AuthService } from '../services/auth.service';
import { QuestionService } from '../services/question.service';
import { ImageService } from '../services/image.service';

@Component({
  selector: 'app-test',
  standalone: true,
  imports: [CommonModule, HttpClientModule], // <-- added HttpClientModule
  templateUrl: './test.component.html'
})
export class TestComponent {
  constructor(
    private auth: AuthService,
    private question: QuestionService,
    private image: ImageService
  ) {}

  register() {
    this.auth.register({
      username: 'user1',
      email: 'user1@test.com',
      password: 'User@123',
      role: 'User'
    }).subscribe(console.log);
  }

  createQuestion() {
    this.question.createQuestion({
      title: 'Test Question',
      body: 'What is EF Core?'
    }).subscribe(console.log);
  }

  uploadImage(event: any) {
    const file = event.target.files[0];
    this.image.upload(file, 1).subscribe(console.log); // replace 1 with actual questionId
  }
}
