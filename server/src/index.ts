import express, { Request, Response} from 'express';
import cors from 'cors';

import authRouter from './routes/auth/auth.route';
import postsRouter from './routes/posts/posts.route';
import usersRouter from './routes/users/users.route';
import categoryRouter from './routes/categories/category.route';

const app = express();
const port = 5000;

app.use(
    cors({
        origin: "http://localhost:3000",
    })
);

app.use(express.json());

app.use('/api/v1/auth' , authRouter);
app.use('/api/v1/posts', postsRouter);
app.use('/api/v1/users', usersRouter);
app.use('/api/v1/categories', categoryRouter);

app.get('/', (req: Request, res: Response) => {
    res.send('Hello World!');
});

app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});