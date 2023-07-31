import { authorizedAPI } from '../configs';
import AuthService from './AuthService';

export type { AuthServiceType } from './AuthService';
export * from './Storage';

export default {
  authApi: AuthService(authorizedAPI)
};
