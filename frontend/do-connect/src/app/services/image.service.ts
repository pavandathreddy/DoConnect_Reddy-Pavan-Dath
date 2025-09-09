import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../environments/environment';

@Injectable({ providedIn: 'root' })
export class ImageService {
  private api = environment.api + '/images';

  constructor(private http: HttpClient) {}

  upload(file: File, questionId: number) {
    const fd = new FormData();
    fd.append('file', file);
    fd.append('questionId', questionId.toString());
    return this.http.post(`${this.api}/upload`, fd);
  }
}
