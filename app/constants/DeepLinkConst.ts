export const domain: string = 'waveforms.page.link';

export const bundleId: string = 'com.simform.waveforms';

export const deepLinkPrefixes = ['waveforms://', `${domain}//`, `https://${domain}`];

export const deepLinkQueryParamsMatch: RegExp = /\?(.+)/;
export const routeReplace: RegExp = /.*?:\/\//g;
export const paramReplace: RegExp = /\/([^\\/]+)\/?$/;

export enum DeepLink {
  // waveforms://magic_link&lang=en&tenantId=austin-electrical-qqm76
  MagicLink = 'magic_link',
  // waveforms://forgot_password&lang=en&tenantId=austin-electrical-qqm76
  ForgotPassword = 'forgot_password',
  // waveforms://?toastMessage=<message content>
  ToastMessage = 'toastMessage'
}

export default DeepLink;
