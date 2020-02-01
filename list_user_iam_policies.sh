#!/bin/bash
username=${1}

echo "======================"
echo "Información del usuario"
aws iam get-user --user-name $username
echo "======================="
echo ""


echo "Grupos del usuario"
echo "==============================================="
Groups=$(aws iam list-groups-for-user --user-name ${username} --output text | awk '{print $5}')
echo "El usuario $username pertenece a $Groups"
echo "==============================================="

echo "Listando las politicas de grupo"
for Group in $Groups
do  
    echo ""
    echo "==============================================="
    echo "Detalle de la politicas de $Group"
    GPolicies=$(aws iam list-attached-group-policies --group-name $Group --output text | awk '{print $2}')
    echo "==============================================="
    echo ""
    for Policy in $GPolicies
    do
        echo "Detalle de la politica ${Policy}"
        PolicyVersion=$(aws iam get-policy --policy-arn ${Policy} --output text | awk '{print $5}')
        aws iam get-policy-version --policy-arn ${Policy} --version-id ${PolicyVersion}
    done

done

echo "Listando las politicas del usuario"
UPolicies=$(aws iam list-attached-user-policies --user-name $username --output text | awk '{print $2}')
if [ -z "${UPolicies}" ]
then
    for Policy in $UPolicies
    do
        echo "Detalle de la politica ${Policy}"
        aws iam get-policy --policy-arn ${Policy}
    done
else
    echo "No hay politicas directamente asignadas al usuario."
fi

