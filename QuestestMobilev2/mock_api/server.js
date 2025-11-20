const jsonServer = require('json-server');
const server = jsonServer.create();
const router = jsonServer.router('db.json');
const middlewares = jsonServer.defaults();

// Use default middlewares (logger, static, cors and no-cache)
server.use(middlewares);

// Parse JSON bodies
server.use(jsonServer.bodyParser);

// Custom routes and middleware

// Login endpoint
server.post('/auth/login', (req, res) => {
  const { email, password } = req.body;
  
  // Get database instance
  const db = router.db;
  
  // Find user by email
  const user = db.get('users').find({ email }).value();
  
  // Simple validation (in production, use proper password hashing)
  if (user && password === 'password123') {
    res.json({
      token: 'mock_jwt_token_' + Date.now(),
      user: user,
      tokenType: 'Bearer',
      expiresIn: 86400
    });
  } else {
    res.status(401).json({ 
      error: 'Invalid credentials',
      message: 'Email or password is incorrect'
    });
  }
});

// Register endpoint
server.post('/auth/register', (req, res) => {
  const { email, name, password } = req.body;
  
  const db = router.db;
  
  // Check if user already exists
  const existingUser = db.get('users').find({ email }).value();
  
  if (existingUser) {
    res.status(400).json({
      error: 'User already exists',
      message: 'An account with this email already exists'
    });
    return;
  }
  
  // Create new user
  const newUser = {
    id: String(Date.now()),
    email,
    name,
    avatarUrl: `https://i.pravatar.cc/150?img=${Math.floor(Math.random() * 70)}`,
    totalQuizzesTaken: 0,
    totalPoints: 0,
    bio: '',
    createdAt: new Date().toISOString()
  };
  
  db.get('users').push(newUser).write();
  
  res.status(201).json({
    token: 'mock_jwt_token_' + Date.now(),
    user: newUser,
    tokenType: 'Bearer',
    expiresIn: 86400
  });
});

// Middleware to simulate authentication check
server.use((req, res, next) => {
  // Skip auth check for public endpoints
  const publicPaths = ['/auth/login', '/auth/register', '/quizzes'];
  const isPublic = publicPaths.some(path => req.path.startsWith(path)) && req.method === 'GET';
  
  if (isPublic) {
    next();
    return;
  }
  
  // Check for authorization header
  const authHeader = req.headers.authorization;
  
  if (req.method !== 'GET' && !authHeader) {
    res.status(401).json({
      error: 'Unauthorized',
      message: 'Authentication required'
    });
    return;
  }
  
  next();
});

// Custom error handler
server.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    error: 'Internal server error',
    message: err.message
  });
});

// Use default router for other endpoints
server.use(router);

// Start server
const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log('🚀 Questest Mock API Server is running!');
  console.log(`📡 Server: http://localhost:${PORT}`);
  console.log(`📚 Resources:`);
  console.log(`   - GET    http://localhost:${PORT}/quizzes`);
  console.log(`   - GET    http://localhost:${PORT}/users/:id`);
  console.log(`   - POST   http://localhost:${PORT}/auth/login`);
  console.log(`   - POST   http://localhost:${PORT}/auth/register`);
  console.log(`\n💡 Tip: Use --delay flag to simulate network latency`);
});

