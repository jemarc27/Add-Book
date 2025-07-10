const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { v4: uuidv4 } = require('uuid');

const app = express();
const PORT = 3000;

app.use(cors());
app.use(bodyParser.json());

let books = [
  // Example book
  // { id: '1', title: 'Sample Book', author: 'Author Name', publishedYear: 2024 }
];

// GET all books
app.get('/api/books', (req, res) => {
  res.json(books);
});

// POST a new book
app.post('/api/books', (req, res) => {
  const { title, author, publishedYear } = req.body;
  const newBook = {
    id: uuidv4(),
    title,
    author,
    publishedYear,
  };
  books.push(newBook);
  res.status(201).json(newBook);
});

// DELETE a book by id
app.delete('/api/books/:id', (req, res) => {
  const { id } = req.params;
  const initialLength = books.length;
  books = books.filter(book => book.id !== id);
  if (books.length < initialLength) {
    res.sendStatus(200);
  } else {
    res.sendStatus(404);
  }
});

app.listen(PORT, () => {
  console.log(Server running on http://localhost:${PORT});
});

