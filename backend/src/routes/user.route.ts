import { Router } from 'express';
import { login, register } from '../controllers/auth.controller';
import { getUser } from '../controllers/user.controller';

const userRouter = Router();

/**
 * @swagger
 * /users/register:
 *   post:
 *     summary: Enregistre un nouvel utilisateur
 *     tags: [Users]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               username:
 *                 type: string
 *                 description: Nom d'utilisateur
 *               email:
 *                 type: string
 *                 description: Adresse e-mail
 *               password:
 *                 type: string
 *                 description: Mot de passe
 *     responses:
 *       201:
 *         description: Utilisateur enregistré avec succès
 *       400:
 *         description: Erreur dans l'enregistrement de l'utilisateur
 */
userRouter.post('/register', register);

/**
 * @swagger
 * /users/login:
 *   post:
 *     summary: Connecte un utilisateur
 *     tags: [Users]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *                 description: Adresse e-mail de l'utilisateur
 *               password:
 *                 type: string
 *                 description: Mot de passe de l'utilisateur
 *     responses:
 *       200:
 *         description: Connexion réussie
 *       401:
 *         description: Identifiants incorrects
 */
userRouter.post('/login', login);

/**
 * @swagger
 * /users:
 *   get:
 *     summary: Récupère les informations de l'utilisateur connecté
 *     tags: [Users]
 *     responses:
 *       200:
 *         description: Informations de l'utilisateur
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 id:
 *                   type: string
 *                 username:
 *                   type: string
 *                 email:
 *                   type: string
 *       401:
 *         description: Non autorisé, l'utilisateur doit être connecté
 */
userRouter.get('', getUser);

export default userRouter;