import { z } from 'zod';

export const regsiterSchema = z.object({
    username: z.string(),
    email: z.email(),
    password: z.string().min(6)
})


export const loginSchema = z.object({
    email: z.email(),
    password: z.string().min(6)
})