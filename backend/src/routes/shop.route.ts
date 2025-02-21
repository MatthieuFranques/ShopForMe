import {Router} from 'express';
import {createShopC, getAllShopsC, getShopByIdC, updateShopC, removeShopC} from '../controllers/shop.controller';

const shopRouter = Router();

/**
 * @swagger
 * /shops:
 *   post:
 *     summary: Crée un nouveau shop
 *     tags: [Shops]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *                 description: Nom du shop
 *               location:
 *                 type: string
 *                 description: Emplacement du shop
 *     responses:
 *       201:
 *         description: Shop créé avec succès
 *       400:
 *         description: Erreur dans la création du shop
 */
shopRouter.post('/', createShopC);

/**
 * @swagger
 * /shops/{id}:
 *   get:
 *     summary: Récupère un shop par son identifiant
 *     tags: [Shops]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: L'identifiant unique du shop
 *     responses:
 *       200:
 *         description: Détails du shop
 *       404:
 *         description: Shop non trouvé
 */
shopRouter.get('/:id', getShopByIdC);

/**
 * @swagger
 * /shops/{id}:
 *   put:
 *     summary: Met à jour un shop par son identifiant
 *     tags: [Shops]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: L'identifiant unique du shop
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *                 description: Nom du shop
 *               location:
 *                 type: string
 *                 description: Emplacement du shop
 *     responses:
 *       200:
 *         description: Shop mis à jour avec succès
 *       400:
 *         description: Erreur dans la mise à jour
 *       404:
 *         description: Shop non trouvé
 */
shopRouter.put('/:id', updateShopC);

/**
 * @swagger
 * /shops/{id}:
 *   delete:
 *     summary: Supprime un shop par son identifiant
 *     tags: [Shops]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: L'identifiant unique du shop
 *     responses:
 *       200:
 *         description: Shop supprimé avec succès
 *       404:
 *         description: Shop non trouvé
 */
shopRouter.delete('/:id', removeShopC);

/**
 * @swagger
 * /shops:
 *   get:
 *     summary: Récupère la liste de tous les shops
 *     tags: [Shops]
 *     responses:
 *       200:
 *         description: Liste des shops
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
 *                   location:
 *                     type: string
 */
shopRouter.get('/', getAllShopsC);

export default shopRouter;