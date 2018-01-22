#!/bin/bash
export AWS_USERNAME="adam.tolley\n"
gather_existing_keys ()
{
#TODO: change each \n-separated profile name to match your own names for each account. (i.e.: what do you call the entries in ~/.aws/config and ~/credentails
#export AWS_ACCOUNT_STRG='wp-sand\nDW\n\Video\nMain\nINF\nENT\n\wp-arc'
export AWS_ACCOUNT_STRG='default\n'

printf %b ${AWS_ACCOUNT_STRG}  | xargs -I % echo %  > .aws_account.txt

printf %b "${AWS_ACCOUNT_STRG}"  | xargs -I % aws iam --profile % list-access-keys --user-name "${AWS_USERNAME}" --output json | jq '.AccessKeyMetadata[] | {UserName, AccessKeyId}| .AccessKeyId' > .keys.txt


if  [[ "$(wc -l .aws_account.txt | cut -f 1 -d \  )" -ne "$(wc -l .keys.txt  | cut -f 1 -d \  )" ]]; then
    echo "the list of aws accounts and keys isn't equal, you most likely have more than one key for one or more AWS account for the given username. You can't run this script."
    exit
else
    paste .aws_account.txt .keys.txt | column -s',' -t | tr -s \  | tr -d \" | sed 's/\t/\,/g' > cmd_args.txt

fi

rm -rf .aws_account.txt .keys.txt

#cat cmd_args.txt

}
setup()
{
export AWS_USERNAME="${1}"
}

create_new_keys()
{
rm -rf ~/credentials.personal.tmp
while read LINE
    do
        AWS_ACCOUNT_NAME="$(echo $LINE | awk 'BEGIN { FS = "," } ; { print $1 }')"
        OLD_AWS_ACCOUNT_ACCESS_KEY="$(echo $LINE | awk 'BEGIN { FS = "," } ; { print $2 }')"
        aws iam --profile "${AWS_ACCOUNT_NAME}" create-access-key --user-name "${AWS_USERNAME}" > .NEW_KEY_MAT_"${AWS_ACCOUNT_NAME}".TXT
        AWS_ACCOUNT_ACCESS_KEY=$(grep "AccessKeyId" .NEW_KEY_MAT_"${AWS_ACCOUNT_NAME}".TXT | sed 's/"AccessKeyId": \(.*\)/\1/g' | tr -d \" | tr -d \,| tr -s \  | tr -d \ )
        echo "${AWS_ACCOUNT_ACCESS_KEY}"

        AWS_ACCOUNT_SECRET_KEY=$(grep "SecretAccessKey" .NEW_KEY_MAT_"${AWS_ACCOUNT_NAME}".TXT | sed 's/"SecretAccessKey": \(.*\)/\1/g' | tr -d \" | tr -d \,| tr -s \  | tr -d \ )
        echo "${AWS_ACCOUNT_SECRET_KEY}"

        aws iam --profile "${AWS_ACCOUNT_NAME}" update-access-key --user-name "${AWS_USERNAME}" --status Inactive --access-key-id "${OLD_AWS_ACCOUNT_ACCESS_KEY}"

        echo "["${AWS_ACCOUNT_NAME}"]" >> ~/credentials.personal.tmp
        echo "aws_access_key_id=""${AWS_ACCOUNT_ACCESS_KEY}" >> ~/credentials.personal.tmp
        echo "aws_secret_access_key=""${AWS_ACCOUNT_SECRET_KEY}" >> ~/credentials.personal.tmp
        #TODO: ENABLING THIS will remove the 'secret' key material, which means you won't be able to access it if the above .tmp file wasn't properly generated.
        #rm -rf .NEW_KEY_MAT_"${AWS_ACCOUNT_NAME}".TXT

done <  "${1}"
#TODO; replace personal credential file.
echo "your new .credentials file is located : " ~/credentials.personal.tmp
}
delete_access_keys()
{
while read LINE
        do
                AWS_ACCOUNT_NAME="$(echo $LINE | awk 'BEGIN { FS = "," } ; { print $1 }')"
                OLD_AWS_ACCOUNT_ACCESS_KEY="$(echo $LINE | awk 'BEGIN { FS = "," } ; { print $2 }')"
                aws iam --profile "${AWS_ACCOUNT_NAME}" delete-access-key --user-name "${AWS_USERNAME}" --access-key "${OLD_AWS_ACCOUNT_ACCESS_KEY}"

done <  "${1}"
}
usage (){
 echo "$0: AWS_USERNAME"
}
tear_down()
{
rm -rf cmd_args.txt
}
[ "$#" -ne 1 ] && ( usage && exit 1 ) || setup "${1}" && gather_existing_keys && create_new_keys cmd_args.txt #&& delete_access_keys cmd_args.txt
tear_down
exit
#TODO; replace personal credential file with ~/credentials.personal.tmp.
