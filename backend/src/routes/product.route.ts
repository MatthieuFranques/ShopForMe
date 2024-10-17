import {Router} from 'express';
import {createProduct, getAllProducts, getProductById, updateProduct, getFreeProduct} from '../controllers/product.controller';

const shopRouter = Router();

shopRouter.get('/getFree/:id', getFreeProduct);
shopRouter.post('/', createProduct);
shopRouter.get('/:id', getAllProducts);
shopRouter.put('/:id', updateProduct);
shopRouter.get('/', getProductById);

export default shopRouter;