RELEASE_VERSION ?= ""
# NOTE: LAYER_NAME must be set in each layer. Default to 'LAYER'
LAYER_NAME ?= "LAYER"
YOCTO_IMAGE_NAME_SUFFIX ?= ""

def get_image_name(d):
    layer_name = d.getVar('LAYER_NAME')
    image_type_id = d.getVar('IMAGE_TYPE_ID')
    release_version = d.getVar('RELEASE_VERSION')

    image_name_ext = ''
    if layer_name:
        image_name_ext += '_' + layer_name
    if image_type_id:
        image_name_ext += '_' + image_type_id

    machine_image_name = d.getVar('MACHINE_IMAGE_NAME')
    project_branch = "${@'develop' if d.getVar('PROJECT_BRANCH') in [None, '', 'nobranch=1'] else d.getVar('PROJECT_BRANCH')}"

    image_name = machine_image_name
    if release_version:
        image_name += f"_{release_version}{image_name_ext}"
    else:
        image_name += f"{image_name_ext}_{project_branch}"

    return image_name

IMAGE_NAME = "${@get_image_name(d)}${@['', '_${DATETIME}'][d.getVar('RELEASE_VERSION') == "" ]}${@['_${YOCTO_IMAGE_NAME_SUFFIX}', ''][d.getVar('YOCTO_IMAGE_NAME_SUFFIX') == "" ]}"
IMAGE_NAME[vardepsexclude] = "DATETIME DATE TIME"
get_image_name[vardepsexclude] = "DATETIME IMAGE_TYPE_ID"
