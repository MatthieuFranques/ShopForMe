import { Router } from 'express';
import {
    createProduct,
    getAllProducts,
    getProductById,
    updateProduct,
    getFreeProduct,
    getAllProductByShopP,
    addNewProductToRayonP,
    getProductsBySectionNameP
} from '../controllers/product.controller';

const shopRouter = Router();

/**
 * @swagger
 * /products/getFree/{id}:
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
 * /products/getAllProductByShop/{id}:
 *   get:
 *     summary: Récupère tous les produits par l'identifiant du magasin
 *     tags: [Products]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: L'identifiant unique du magasin
 *     responses:
 *       200:
 *         description: Liste des produits du magasin
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
 *       404:
 *         description: Magasin non trouvé
 */
shopRouter.get('/getAllProductByShop/:id', getAllProductByShopP);

/**
 * @swagger
 * /products/addNewProductToRayonP:
 *   post:
 *     summary: Ajoute un nouveau produit au rayon
 *     tags: [Products]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               rayonId:
 *                 type: string
 *                 description: ID du rayon
 *               productId:
 *                 type: string
 *                 description: ID du produit à ajouter
 *     responses:
 *       200:
 *         description: Produit ajouté avec succès
 *       400:
 *         description: Erreur dans l'ajout du produit
 *       404:
 *         description: Rayon ou produit non trouvé
 */
shopRouter.post('/addNewProductToRayonP', addNewProductToRayonP);

/**
 * @swagger
 * /products/getProductsBySectionName/{name}:
 *   get:
 *     summary: Récupère les produits par nom de section
 *     tags: [Products]
 *     parameters:
 *       - in: path
 *         name: name
 *         required: true
 *         schema:
 *           type: string
 *         description: L'identifiant unique du produit
 *     responses:
 *       200:
 *         description: Produits récupérés avec succès
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
 *       400:
 *         description: Erreur dans le format de la requête
 *       404:
 *         description: Produits non trouvés pour la section donnée
 */
shopRouter.get('/getProductsBySectionName/:id', getProductsBySectionNameP);

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
 * /products:
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
 * /products/{id}:
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
 * /products/{id}:
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