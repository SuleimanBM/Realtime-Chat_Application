import { Router } from 'express';
import * as chatController from '../controllers/chatController.js';

const router = Router();

router.post('/search-username', chatController.searchUsers);
// router.post('/login', chatController.login);

export default router;