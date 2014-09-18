// category + class method
// NSString+StringWithContentsOfURLExt.m

#import "NSString+StringWithContentsOfURLExt.h"

// $ defaults read com.google.code.quicklookcsv tryingTextEncoding
# define  KEYTRYINGTEXTENCODING  @"tryingTextEncoding"
# define  DEFAULTTRYINGTEXTENCODING  @"CP932"
// # define  DEFAULTTRYINGTEXTENCODING  @"ISO-8859-1"

NSStringEncoding getTryingTextEncoding();
CFStringEncoding CFStringEncodingFromEncodingName(NSString *enc_name);

@implementation NSString (StringWithContentsOfURLExt)
+ (NSString*)StringWithContentsOfURLExt:(NSURL *)url usedEncoding:(NSStringEncoding *)enc error:(NSError **)error
{
  NSString *fileString = [NSString stringWithContentsOfURL:url usedEncoding:enc error:error];
  if (!fileString) {
    *enc = getTryingTextEncoding();
    fileString = [NSString stringWithContentsOfURL:url encoding:*enc error:error];
  }
  return fileString;
}
@end

NSStringEncoding getTryingTextEncoding()
{
  CFStringEncoding cf_enc;
  NSString *enc_name = [NSUserDefaults.standardUserDefaults stringForKey:KEYTRYINGTEXTENCODING];
  if (enc_name) {
    cf_enc = CFStringEncodingFromEncodingName(enc_name);
    if (cf_enc == kCFStringEncodingInvalidId) enc_name = nil;
    }
  if (!enc_name) {
    enc_name = DEFAULTTRYINGTEXTENCODING;
    cf_enc = CFStringEncodingFromEncodingName(enc_name);
    [NSUserDefaults.standardUserDefaults setObject:enc_name forKey:KEYTRYINGTEXTENCODING];
    [NSUserDefaults.standardUserDefaults synchronize];
  }
  return CFStringConvertEncodingToNSStringEncoding(cf_enc);
}

CFStringEncoding CFStringEncodingFromEncodingName(NSString *enc_name)
{
  return CFStringConvertIANACharSetNameToEncoding((CFStringRef)enc_name);
}
