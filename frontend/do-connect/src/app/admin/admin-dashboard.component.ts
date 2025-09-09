import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router'; // For routerLink usage
import { AdminService } from '../services/admin.service';
import { Question, Answer } from '../services/question.service';

@Component({
  selector: 'app-admin-dashboard',
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    RouterModule
  ],
  templateUrl: './admin-dashboard.component.html',
  // styleUrls: ['./admin-dashboard.component.css'] // Uncomment if needed
})
export class AdminDashboardComponent implements OnInit {
  pendingQuestions: Question[] = [];
  pendingAnswers: Answer[] = [];
  loading = true;
  error = '';
  activeTab = 'questions';

  constructor(private adminService: AdminService) {}

  ngOnInit(): void {
    this.loadPendingItems();
  }

  loadPendingItems(): void {
    this.loading = true;

    this.adminService.getPendingQuestions().subscribe({
      next: (questions) => {
        this.pendingQuestions = questions;
        this.checkLoadingComplete();
      },
      error: () => {
        this.error = 'Failed to load pending questions';
        this.checkLoadingComplete();
      }
    });

    this.adminService.getPendingAnswers().subscribe({
      next: (answers) => {
        this.pendingAnswers = answers;
        this.checkLoadingComplete();
      },
      error: () => {
        this.error = 'Failed to load pending answers';
        this.checkLoadingComplete();
      }
    });
  }

  private checkLoadingComplete(): void {
    this.loading = false;
  }

  approveQuestion(questionId: number): void {
    this.adminService.approveQuestion(questionId).subscribe({
      next: () => {
        this.pendingQuestions = this.pendingQuestions.filter(q => q.questionId !== questionId);
        alert('Question approved successfully');
      },
      error: () => alert('Failed to approve question')
    });
  }

  rejectQuestion(questionId: number): void {
    this.adminService.rejectQuestion(questionId).subscribe({
      next: () => {
        this.pendingQuestions = this.pendingQuestions.filter(q => q.questionId !== questionId);
        alert('Question rejected successfully');
      },
      error: () => alert('Failed to reject question')
    });
  }

  deleteQuestion(questionId: number): void {
    if (confirm('Are you sure you want to permanently delete this question?')) {
      this.adminService.deleteQuestion(questionId).subscribe({
        next: () => {
          this.pendingQuestions = this.pendingQuestions.filter(q => q.questionId !== questionId);
          alert('Question deleted successfully');
        },
        error: () => alert('Failed to delete question')
      });
    }
  }

  approveAnswer(answerId: number): void {
    this.adminService.approveAnswer(answerId).subscribe({
      next: () => {
        this.pendingAnswers = this.pendingAnswers.filter(a => a.answerId !== answerId);
        alert('Answer approved successfully');
      },
      error: () => alert('Failed to approve answer')
    });
  }

  rejectAnswer(answerId: number): void {
    this.adminService.rejectAnswer(answerId).subscribe({
      next: () => {
        this.pendingAnswers = this.pendingAnswers.filter(a => a.answerId !== answerId);
        alert('Answer rejected successfully');
      },
      error: () => alert('Failed to reject answer')
    });
  }

  deleteAnswer(answerId: number): void {
    if (confirm('Are you sure you want to permanently delete this answer?')) {
      this.adminService.deleteAnswer(answerId).subscribe({
        next: () => {
          this.pendingAnswers = this.pendingAnswers.filter(a => a.answerId !== answerId);
          alert('Answer deleted successfully');
        },
        error: () => alert('Failed to delete answer')
      });
    }
  }

  setActiveTab(tab: string): void {
    this.activeTab = tab;
  }
}
