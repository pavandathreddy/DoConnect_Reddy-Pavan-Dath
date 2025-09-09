import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { HttpClient, HttpClientModule } from '@angular/common/http';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-question-detail',
  standalone: true,
  imports: [
    CommonModule,
    ReactiveFormsModule,
    FormsModule,         // 👈 Needed for ngForm
    HttpClientModule
  ],
  templateUrl: './question-detail.component.html',
  styleUrls: ['./question-detail.component.css']
})
export class QuestionDetailComponent implements OnInit {
  question: any;
  answers: any[] = [];
  answerForm: FormGroup;
  selectedFile: File | null = null;

  constructor(
    private route: ActivatedRoute,
    private http: HttpClient,
    private fb: FormBuilder
  ) {
    this.answerForm = this.fb.group({
      text: ['', Validators.required]
    });
  }

  ngOnInit() {
    const id = this.route.snapshot.params['id'];
    this.http.get<any>(`http://localhost:5291/api/questions/${id}`).subscribe(data => {
      this.question = data;
      this.answers = data.answers || [];
    });
  }

  submitAnswer() {
    if (this.answerForm.invalid) return;
    const id = this.route.snapshot.params['id'];
    this.http.post<any>(`http://localhost:5291/api/questions/${id}/answers`, this.answerForm.value)
      .subscribe(answer => {
        this.answers.push(answer);
        this.answerForm.reset();
      });
  }

  onFileSelected(event: any) {
    this.selectedFile = event.target.files[0];
  }

  uploadImage() {
    if (!this.selectedFile) return;

    const id = this.route.snapshot.params['id'];
    const formData = new FormData();
    formData.append('file', this.selectedFile);

    this.http.post<any>(`http://localhost:5291/api/questions/${id}/images`, formData)
      .subscribe({
        next: () => alert('Image uploaded successfully'),
        error: () => alert('Image upload failed')
      });
  }
}
