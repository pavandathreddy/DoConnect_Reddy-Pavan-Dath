import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common'; // For *ngIf, *ngFor
import { QuestionService } from '../services/question.service';
import { AuthService } from '../services/auth.service';

@Component({
  selector: 'app-ask-question',
  standalone: true,
  imports: [
    CommonModule,          // For *ngIf, *ngFor
    ReactiveFormsModule    // For [formGroup], form controls
  ],
  templateUrl: './ask-question.component.html',
})
export class AskQuestionComponent implements OnInit {
  questionForm!: FormGroup;
  loading = false;
  submitted = false;
  error = '';
  selectedFiles: File[] = [];

  constructor(
    private formBuilder: FormBuilder,
    private router: Router,
    private questionService: QuestionService,
    private authService: AuthService
  ) {
    // Redirect to login if not authenticated
    if (!this.authService.isAuthenticated()) {
      this.router.navigate(['/login']);
    }
  }

  ngOnInit(): void {
    this.questionForm = this.formBuilder.group({
      title: ['', [Validators.required, Validators.minLength(10)]],
      body: ['', [Validators.required, Validators.minLength(20)]]
    });
  }

  get f() { return this.questionForm.controls; }

  onFileSelect(event: any): void {
    this.selectedFiles = Array.from(event.target.files);
  }

  onSubmit(): void {
    this.submitted = true;
    if (this.questionForm.invalid) return;

    this.loading = true;
    this.questionService.createQuestion(this.questionForm.value).subscribe({
      next: (question) => {
        if (this.selectedFiles.length > 0) {
          this.uploadQuestionImages(question.questionId);
        } else {
          this.onQuestionCreated();
        }
      },
      error: () => {
        this.error = 'Failed to create question';
        this.loading = false;
      }
    });
  }

  uploadQuestionImages(questionId: number): void {
    let uploadCount = 0;
    this.selectedFiles.forEach(file => {
      this.questionService.uploadImage(file, questionId).subscribe({
        next: () => { this.checkUploadComplete(++uploadCount); },
        error: () => { this.checkUploadComplete(++uploadCount); }
      });
    });
  }

  private checkUploadComplete(count: number) {
    if (count === this.selectedFiles.length) {
      this.onQuestionCreated();
    }
  }

  onQuestionCreated(): void {
    alert('Question submitted successfully! It will be visible after admin approval.');
    this.router.navigate(['/']);
  }

  // ✅ Public method for Cancel button
  cancel(): void {
    this.router.navigate(['/']);
  }
}
