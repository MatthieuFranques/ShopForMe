import {Router} from 'express';
import {createShopC, getAllShopsC, getShopByIdC, updateShopC} from '../controllers/shop.controller';

const shopRouter = Router();

shopRouter.post('/', createShopC);
shopRouter.get('/:id', getShopByIdC);
shopRouter.put('/:id', updateShopC);
shopRouter.get('/', getAllShopsC);

export default shopRouter;