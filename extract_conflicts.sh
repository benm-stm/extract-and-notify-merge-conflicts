#!/bin/bash

# sends email using sendmail
email(){
  email="$1"; subject="$2"; fromname="$3"; from="$4"; content="$5"
  {
    echo "Subject: $subject"
    echo "From: $fromname <$from>";
    echo "To: $email";
    echo "$content"
  } | $(which sendmail) -F "$from" "$email"
}

merge_branches(){
  source="$1"
  git merge origin/$source
}

get_log(){
  file=$1;opt=$2
  user_mails_to_notify=`git log -n 1 --pretty=format:"$2" $file`
  echo $user_mails_to_notify
}

get_conflict_files(){
  conflict_files=( `git diff --name-only --diff-filter=U` )
  echo $conflict_files
}

##### MAIN ######
#Params
devops_mail_body="Merge conflicts have been detected between ${BRANCHESOURCE} and ${BRANCHESOURCE}"
user_mail_body="Merge conflicts have been detected between ${BRANCHESOURCE} and ${BRANCHESOURCE} because of your last commit"
mail_subject="Merge conflicts ${BRANCHESOURCE} ${BRANCHESOURCE}"
mail_from="jenkins@laposte.fr"
devops_mail="ld-corp-devops-bnum@laposte.fr"

# merge branches
merge_branches ${BRANCHESOURCE}

#get conflict files in an array
conflict_files=( get_conflict_files() )


for file in "${conflict_files[@]}"
do
	#get email
    get_log $file "%ae"

	#get username
    get_log $file "%an"
    
    email "raf.gmail.com" $mail_subject "Jenkins" $mail_from $user_mail_body_tmp
    
    #construct devops mail
    devops_mail_body="$devops_mail_body <br> => $user_names_to_notify : $user_mails_to_notify"
    
done

devops_mail_body="$devops_mail_body <br> Best Regards"

email "med-rafik.ben-mansour-prestataire@laposte.fr" $mail_subject "Jenkins" $mail_from $devops_mail_body
