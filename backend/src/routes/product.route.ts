import { Router } from 'express';
import { createProduct, getAllProducts, getProductById, updateProduct, getFreeProduct } from '../controllers/product.controller';

const shopRouter = Router();

/**
 * @swagger
 * /product/getFree/{id}:
 *   get:
 *     summary: Récupère un produit gratuit par son identifiant
 *     tags: [Products]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: L'identifiant unique du produit
 *     responses:
 *       200:
 *         description: Détails du produit gratuit
 *       404:
 *         description: Produit non trouvé
 */
shopRouter.get('/getFree/:id', getFreeProduct);

/**
 * @swagger
 * /products:
 *   post:
 *     summary: Crée un nouveau produit
 *     tags: [Products]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *                 description: Nom du produit
 *               price:
 *                 type: number
 *                 description: Prix du produit
 *               description:
 *                 type: string
 *                 description: Description du produit
 *     responses:
 *       201:
 *         description: Produit créé avec succès
 *       400:
 *         description: Erreur dans la création du produit
 */
shopRouter.post('/', createProduct);

/**
 * @swagger
 * /product:
 *   get:
 *     summary: Récupère la liste de tous les produits
 *     tags: [Products]
 *     responses:
 *       200:
 *         description: Liste des produits
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   id:
 *                     type: string
 *                   name:
 *                     type: string
 *                   price:
 *                     type: number
 *                   description:
 *                     type: string
 */
shopRouter.get('/', getAllProducts);

/**
 * @swagger
 * /product/{id}:
 *   put:
 *     summary: Met à jour un produit par son identifiant
 *     tags: [Products]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: L'identifiant unique du produit
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *                 description: Nom du produit
 *               price:
 *                 type: number
 *                 description: Prix du produit
 *               description:
 *                 type: string
 *                 description: Description du produit
 *     responses:
 *       200:
 *         description: Produit mis à jour avec succès
 *       400:
 *         description: Erreur dans la mise à jour
 *       404:
 *         description: Produit non trouvé
 */
shopRouter.put('/:id', updateProduct);

/**
 * @swagger
 * /product/{id}:
 *   get:
 *     summary: Récupère un produit par son identifiant
 *     tags: [Products]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: L'identifiant unique du produit
 *     responses:
 *       200:
 *         description: Détails du produit
 *       404:
 *         description: Produit non trouvé
 */
shopRouter.get('/:id', getProductById);

export default shopRouter;