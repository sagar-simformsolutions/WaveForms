import { apiWithCancelToken } from '../configs';
import { APIConst } from '../constants';
import { UserResponse } from '../models';
import type { ApiResponse, ApisauceInstance } from 'apisauce';

export interface AuthServiceType {
  signIn: (credentials: Record<string, any>) => Promise<ApiResponse<UserResponse>>;
}

/**
 * Creates an AuthServiceType object that can be used to auth module API.
 * @param {ApisauceInstance} api - The Api object to use for the API calls.
 * @returns {AuthServiceType} - An object that can be used to auth module API.
 */
const authService = (api: ApisauceInstance) => (): AuthServiceType => {
  /**
   * Signs in the user with the given credentials.
   * @param {SignInRequest} credentials - The credentials to sign in with.
   * @returns {Promise<ApiResponse<SuccessUserResponse>>} - The response from the server.
   */
  function signIn(credentials: Record<string, any>): Promise<ApiResponse<UserResponse>> {
    return apiWithCancelToken<UserResponse>(api, 'POST', APIConst.signin, {
      params: credentials
    });
  }

  return {
    signIn
  };
};

export default authService;
