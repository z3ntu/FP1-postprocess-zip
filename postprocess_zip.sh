#!/bin/bash

set -e

tmp=$(mktemp -d)
zip_path=$PWD/FP1-4.4.2-z3ntu-0.0.4.zip

updater_script=META-INF/com/google/android/updater-script
apns_conf=system/etc/apns-conf.xml
modem_firmware=system/etc/firmware/modem_1_3g_n.img

if test -f $zip_path; then
    echo $zip_path already exists. Remove the zip before running the script.
    exit
fi

# Copy output zip to target path
cp out/target/product/ahong89_wet_jb2/ahong89_wet_jb2-ota-eng..zip $zip_path

# Extract the updater-script
unzip -d $tmp $zip_path $updater_script
sed -i 's|ahong89_wet_jb2|FP1|g' $tmp/$updater_script
# Download the apns-conf
mkdir -p $tmp/$(dirname $apns_conf)
curl https://raw.githubusercontent.com/LineageOS/android_vendor_lineage/lineage-16.0/prebuilt/common/etc/apns-conf.xml -o $tmp/$apns_conf
# Download the modem firmware
mkdir -p $tmp/$(dirname $modem_firmware)
curl https://raw.githubusercontent.com/FairBlobs/FP1-firmware/master/modem_1_3g_n.img -o $tmp/$modem_firmware

# Update the zip with the new files
pushd $tmp
zip --update $zip_path $updater_script
zip --update $zip_path $apns_conf
popd

echo "OTA zip at $zip_path"
