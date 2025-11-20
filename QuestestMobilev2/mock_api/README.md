# Questest Mock API Documentation

## Overview
This mock API is built using `json-server` to simulate backend endpoints during development. It provides a RESTful API with full CRUD operations.

## Setup Instructions

### Prerequisites
- Node.js and npm installed
- json-server package

### Installation

```bash
npm install -g json-server
```

### Running the Mock Server

Navigate to the `mock_api` directory and run:

```bash
json-server --watch db.json --port 3000
```

The server will start at: `http://localhost:3000`

### Alternative: Run with custom routes

Create a `routes.json` file for custom endpoints:

```bash
json-server --watch db.json --routes routes.json --port 3000
```

## API Endpoints

### Base URL
```
http://localhost:3000
```

---

## 📚 Quizzes

### Get All Quizzes
```http
GET /quizzes
```

**Response:**
```json
[
  {
    "id": "1",
    "title": "Sonic the Hedgehog Trivia",
    "subtitle": "Eggman",
    "thumbnailUrl": "https://images.unsplash.com/photo-1511512578047-dfb367046420?w=800",
    "questionCount": 15,
    "participantsCount": 12450,
    "description": "Test your knowledge about the fastest hedgehog in gaming history!",
    "timeLimit": 300,
    "difficulty": "medium"
  }
]
```

### Get Quiz by ID
```http
GET /quizzes/{id}
```

**Example:**
```http
GET /quizzes/1
```

**Response:**
```json
{
  "id": "1",
  "title": "Sonic the Hedgehog Trivia",
  "subtitle": "Eggman",
  "thumbnailUrl": "https://images.unsplash.com/photo-1511512578047-dfb367046420?w=800",
  "questionCount": 15,
  "participantsCount": 12450,
  "description": "Test your knowledge about the fastest hedgehog in gaming history!",
  "timeLimit": 300,
  "difficulty": "medium"
}
```

### Filter Quizzes
```http
GET /quizzes?difficulty=easy
GET /quizzes?_sort=participantsCount&_order=desc
```

---

## 👤 Users

### Get User by ID
```http
GET /users/{id}
```

**Example:**
```http
GET /users/1
```

**Response:**
```json
{
  "id": "1",
  "email": "john.doe@example.com",
  "name": "John Doe",
  "avatarUrl": "https://i.pravatar.cc/150?img=1",
  "totalQuizzesTaken": 24,
  "totalPoints": 1250,
  "bio": "Quiz enthusiast and lifelong learner",
  "createdAt": "2024-01-15T10:30:00Z"
}
```

### Update User Profile
```http
PATCH /users/{id}
```

**Request Body:**
```json
{
  "name": "John Updated",
  "bio": "Updated bio"
}
```

---

## 🔐 Authentication

> **Note:** json-server doesn't natively support authentication. For login, you'll need to implement custom middleware or use the workaround below.

### Login (Workaround)
Since json-server doesn't support POST authentication out of the box, here's the expected contract:

**Request:**
```http
POST /auth/login
Content-Type: application/json

{
  "email": "john.doe@example.com",
  "password": "password123"
}
```

**Expected Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "1",
    "email": "john.doe@example.com",
    "name": "John Doe",
    "avatarUrl": "https://i.pravatar.cc/150?img=1",
    "totalQuizzesTaken": 24,
    "totalPoints": 1250,
    "bio": "Quiz enthusiast and lifelong learner",
    "createdAt": "2024-01-15T10:30:00Z"
  },
  "tokenType": "Bearer",
  "expiresIn": 86400
}
```

**To implement login with json-server:**

1. Install json-server with middleware:
```bash
npm install json-server
```

2. Create `server.js`:
```javascript
const jsonServer = require('json-server');
const server = jsonServer.create();
const router = jsonServer.router('db.json');
const middlewares = jsonServer.defaults();

server.use(middlewares);
server.use(jsonServer.bodyParser);

// Custom login route
server.post('/auth/login', (req, res) => {
  const { email, password } = req.body;
  
  // Simple validation (in production, use proper authentication)
  if (email === 'john.doe@example.com' && password === 'password123') {
    const db = router.db; // Get database
    const user = db.get('users').find({ email }).value();
    
    res.json({
      token: 'mock_jwt_token_' + Date.now(),
      user: user,
      tokenType: 'Bearer',
      expiresIn: 86400
    });
  } else {
    res.status(401).json({ 
      message: 'Invalid credentials' 
    });
  }
});

server.use(router);

server.listen(3000, () => {
  console.log('JSON Server is running on port 3000');
});
```

3. Run with:
```bash
node server.js
```

---

## 📊 Quiz Results

### Get User's Quiz Results
```http
GET /quizResults?userId={userId}
```

**Example:**
```http
GET /quizResults?userId=1
```

### Submit Quiz Result
```http
POST /quizResults
Content-Type: application/json

{
  "userId": "1",
  "quizId": "1",
  "score": 85,
  "totalQuestions": 15,
  "correctAnswers": 13,
  "timeSpent": 240,
  "completedAt": "2024-11-13T10:30:00Z"
}
```

---

## ❓ Questions

### Get Questions for a Quiz
```http
GET /questions?quizId={quizId}
```

**Example:**
```http
GET /questions?quizId=1
```

---

## Advanced Queries

json-server supports various query parameters:

### Filtering
```http
GET /quizzes?difficulty=easy
GET /users?totalPoints_gte=1000
```

### Pagination
```http
GET /quizzes?_page=1&_limit=10
```

### Sorting
```http
GET /quizzes?_sort=participantsCount&_order=desc
```

### Full-text Search
```http
GET /quizzes?q=sonic
```

### Relationships
```http
GET /quizzes?_embed=questions
GET /questions?_expand=quiz
```

---

## Testing with cURL

### Get all quizzes:
```bash
curl http://localhost:3000/quizzes
```

### Get specific quiz:
```bash
curl http://localhost:3000/quizzes/1
```

### Create new quiz:
```bash
curl -X POST http://localhost:3000/quizzes \
  -H "Content-Type: application/json" \
  -d '{
    "title": "New Quiz",
    "subtitle": "Author",
    "thumbnailUrl": "https://example.com/image.jpg",
    "questionCount": 10,
    "participantsCount": 0,
    "difficulty": "easy"
  }'
```

---

## CORS Configuration

json-server automatically enables CORS, so you can make requests from your Flutter app without issues.

---

## Notes for Development

1. **Data Persistence**: Changes made through the API are persisted to `db.json`
2. **Automatic ID Generation**: When creating resources, IDs are auto-generated
3. **Validation**: json-server provides basic validation but no authentication
4. **Realistic Delays**: Add `--delay` flag to simulate network latency:
   ```bash
   json-server --watch db.json --port 3000 --delay 1000
   ```

---

## Production Considerations

When moving to production:

1. Replace mock API URLs in `lib/core/network/dio_client.dart`
2. Implement proper authentication with JWT tokens
3. Add request/response interceptors for token refresh
4. Implement proper error handling
5. Add request retries and timeout configurations
6. Use environment variables for API URLs

---

## Support

For json-server documentation, visit: https://github.com/typicode/json-server

